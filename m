Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbaH2Irp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 04:47:45 -0400
Received: from sender1.zohomail.com ([72.5.230.103]:61312 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaH2Irn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 04:47:43 -0400
X-Greylist: delayed 1936 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Aug 2014 04:47:43 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; 
  s=zapps768; d=zoho.com; 
  h=date:from:to:cc:message-id:in-reply-to:references:subject:mime-version:content-type:user-agent; 
  b=V9jZAUgr3MLHcXn+8UEJkgDNpBGJzGqbriKC29EX90z0UMb6f4J+tDsLVDALHWHvt6hqk75A/WxM
    WzPjt0ywvxP49oUAa3yjHukKgIS7wGnviVkIGaCnBT2HrKFFcj5n  
Date: Fri, 29 Aug 2014 11:53:18 +0400
From: Vitaly Rybnikov <frodox@zoho.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        <richard.weinberger@gmail.com>,
        <containers@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>
Message-ID: <14820c115f6.f730a96c253877.2650827516078037638@zoho.com>
In-Reply-To: <53F5315D.6090003@gmail.com>
References: <53F5315D.6090003@gmail.com>
Subject: Re: For review: namespaces(7) man page
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Priority: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Michael et al.

You have an errata here:

> /proc/[pid]/ns/uts (since Linux 3.0) 
> This file is a handle for the IPC namespace of the 
> process. 

It should be:
/proc/[pid]/ns/uts (since Linux 3.0) 
This file is a handle for the UTS namespace of the 
process. 

---
Regards,
Vitaly.

