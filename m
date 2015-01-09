Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281AbbAIVgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 16:36:48 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:34428 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758260AbbAIVgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 16:36:46 -0500
From: Paul Moore <paul@paul-moore.com>
To: Calvin Owens <calvinowens@fb.com>
Cc: Eric Paris <eparis@redhat.com>, rgb@redhat.com, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org, kernel-team@fb.com,
        stable@vger.kernel.org, linux-audit@redhat.com
Subject: Re: [PATCH][RESEND 2] Revert "AUDIT: Allow login in non-init namespaces"
Date: Fri, 09 Jan 2015 16:36:39 -0500
Message-ID: <4124626.alCBS2pqnO@sifl>
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20150109212451.GG27996@mail.thefacebook.com>
References: <1415148371-11742-1-git-send-email-calvinowens@fb.com> <1569326.X07DWxmoQX@sifl> <20150109212451.GG27996@mail.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 09, 2015 01:24:51 PM Calvin Owens wrote:
> On Friday 01/09 at 15:33 -0500, Paul Moore wrote:
> > While I haven't had reason to test this code lately, last I knew it was
> > working, what problems are you seeing Calvin?  Also, with what
> > distribution?
>
> An SSH authentication setup in LXC containers on CentOS broke with the
> original patch. My revert made it work again. I can dig up more detail
> about the specific setup if you're interested.

Yes, please.  I believe it is the little details that are important for this 
issue.

-- 
paul moore
www.paul-moore.com

