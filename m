Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712AbaL3OLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 09:11:35 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:37861 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaL3OLe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 09:11:34 -0500
From: Paul Moore <paul@paul-moore.com>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux Kernel <linux-kernel@vger.kernel.org>, linux-audit@redhat.com
Subject: Re: v3.19-rc2: crashes during boot (syslog-ng, rpcbind ...)
Date: Tue, 30 Dec 2014 09:11:32 -0500
Message-ID: <5490032.bFDrnJqxyv@sifl>
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <54A1B724.8070106@gmx.de>
References: <54A17C49.5080102@gmx.de> <4182091.odzUCAWhED@sifl> <54A1B724.8070106@gmx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, December 29, 2014 09:18:44 PM Toralf Förster wrote:
> On 12/29/2014 08:41 PM, Paul Moore wrote:
> > To help verify that I'm heading down the right path, could you share your
> > audit configuration as well?  If that's not possible, can you at least
> > confirm that you using a few audit directory watches?
> 
> Well, it is just a victim system for trinity - but I did not configured
> auditd in a special manner - so it is just the plain default configuration
> of Gentoo:

Okay, thanks for the information; the file related syscall watches are likely 
what triggered the problem code.  Until I've got the fix sorted out, removing 
the syscall watches or just disabling auditd from starting at boot should 
workaround the problem.

-- 
paul moore
www.paul-moore.com

