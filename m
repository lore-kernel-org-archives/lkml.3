Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbaLaPQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 10:16:38 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:41178 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaLaPQh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 10:16:37 -0500
From: Paul Moore <paul@paul-moore.com>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux Kernel <linux-kernel@vger.kernel.org>, linux-audit@redhat.com
Subject: Re: v3.19-rc2: crashes during boot (syslog-ng, rpcbind ...)
Date: Wed, 31 Dec 2014 10:16:34 -0500
Message-ID: <7765892.sZQO3B6Ktp@sifl>
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <54A3D68C.8070803@gmx.de>
References: <54A17C49.5080102@gmx.de> <4559278.bMkG2euyQm@sifl> <54A3D68C.8070803@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 31, 2014 11:57:16 AM Toralf Förster wrote:
> On 12/30/2014 07:46 PM, Paul Moore wrote:
> > @@ -1862,7 +1864,7 @@ void __audit_inode(struct filename *name, const
> > struct dentry *dentry,
> 
> repairing this line and applying it to 3.19-rc2 of the KVM seems to solve
> the issue

Great, thanks for testing.  I'll post out a proper patch today, update the 
audit tree, and send a pull request to Linus.

-- 
paul moore
www.paul-moore.com

