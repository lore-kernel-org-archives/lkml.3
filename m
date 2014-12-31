Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbaLaK52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 05:57:28 -0500
Received: from mout.gmx.net ([212.227.15.15]:56670 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbaLaK51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 05:57:27 -0500
Message-ID: <54A3D68C.8070803@gmx.de>
Date: Wed, 31 Dec 2014 11:57:16 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Paul Moore <paul@paul-moore.com>
CC: linux Kernel <linux-kernel@vger.kernel.org>, linux-audit@redhat.com
Subject: Re: v3.19-rc2: crashes during boot (syslog-ng, rpcbind ...)
References: <54A17C49.5080102@gmx.de> <54A1B724.8070106@gmx.de> <5490032.bFDrnJqxyv@sifl> <4559278.bMkG2euyQm@sifl>
In-Reply-To: <4559278.bMkG2euyQm@sifl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:3JSnGv6E0HS2Pt5QoA/4JpY67rtlv1Ex3GdTtwvRfddrGk0NqGD
 VBL4qShincv1UApDccwWCJJDX2ig1/N/6Jcexrr4Y21Y2Q2S8sizHMQzXleSO3h8w7bVsjY
 Hhqk+7RgHIrOj1xzdQg73/oBNyO4ptsraufPo2ePTATEAXW7rGY4F70dvEa/zN1K4yzFWlk
 5KmKpwFmSS+9OL70SvvCA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2014 07:46 PM, Paul Moore wrote:
>  
> @@ -1862,7 +1864,7 @@ void __audit_inode(struct filename *name, const struct 
> dentry *dentry,
>  
repairing this line and applying it to 3.19-rc2 of the KVM seems to solve the issue

Thx

-- 
Toralf
pgp key: 7B1A 07F4 EC82 0F90 D4C2  8936 872A E508 0076 E94E

