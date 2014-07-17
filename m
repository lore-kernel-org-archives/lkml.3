Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071AbaGQVj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 17:39:26 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:36809 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbaGQVjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 17:39:24 -0400
Date: Thu, 17 Jul 2014 14:39:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lennox Wu <lennox.wu@gmail.com>
cc: Guenter Roeck <linux@roeck-us.net>, Liqin Chen <liqin.linux@gmail.com>,
        Chen Gang <gang.chen.5i5j@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] arch/score/include/uapi/asm/ptrace.h: Remove the
 macros which not be used currently
In-Reply-To: <CAF0htA6awFMsfPRRr9=s4Hcxcu586WHWRwyg=C0zc2Yr7CyvKQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1407171437270.5185@chino.kir.corp.google.com>
References: <53AC10CB.3000007@gmail.com> <alpine.DEB.2.02.1406261456150.12443@chino.kir.corp.google.com> <alpine.DEB.2.02.1407161849090.19429@chino.kir.corp.google.com> <CAF0htA5eVTPQC0c1XfzU=RHnNWLtRgtYbN+se5HPLYkJ9_E=5w@mail.gmail.com> <53C73534.1090502@roeck-us.net>
 <CAF0htA6awFMsfPRRr9=s4Hcxcu586WHWRwyg=C0zc2Yr7CyvKQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014, Lennox Wu wrote:

> Yes, you might miss something. Some patches were merged once I
> acknowledged them,and some were missed.
> So I am not sure the rule, if someone will merge these patches once
> them are acknowledged, it is redundant that I issue a
> PULL request again.
> 

You and Liqin Chen are the listed maintainers for this architecture and 
you do not list a git tree, nobody else is a maintainer for score.  Who 
are you expecting to pick up patches to your architecture?  As maintainer, 
you need to ensure that patches arrive at Linus's tree in one way or 
another, so what is your mechanism for doing so?
