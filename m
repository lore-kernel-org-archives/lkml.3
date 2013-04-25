Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829Ab3DYPeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 11:34:06 -0400
Received: from aa.linuxbox.com ([69.128.83.226]:3816 "EHLO aa.linuxbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811Ab3DYPeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 11:34:04 -0400
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Apr 2013 11:34:04 EDT
Date: Thu, 25 Apr 2013 11:28:21 -0400 (EDT)
From: "Matt W. Benjamin" <matt@linuxbox.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: David Wysochanski <dwysocha@redhat.com>,
        Dave Chiluk <chiluk@canonical.com>, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, bfields@fieldses.org
Message-ID: <916743278.65.1366903701195.JavaMail.root@thunderbeast.private.linuxbox.com>
In-Reply-To: <1366899034.6812.4.camel@leira.trondhjem.org>
Subject: Re: [PATCH] NFSv4: Use exponential backoff delay for Ni
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.1.1.213]
X-Mailer: Zimbra 6.0.5_GA_2180.CentOS5_64 (ZimbraWebClient - FF3.0 (Win)/6.0.5_GA_2180.CentOS5_64)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.0.2 (aa.linuxbox.com [10.1.1.1]); Thu, 25 Apr 2013 11:28:24 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just to clarify, the IBM delay behavior is not legal?

Matt

----- "Trond Myklebust" <Trond.Myklebust@netapp.com> wrote:

> 
> OK, then. Now all I need is actual motivation for changing the
> existing
> code other than handwaving arguments about "polling is better than
> flat
> waits".
> What actual use cases are impacting us now, other than the AIX design
> decision to force CLOSE to retry at least once before succeeding?
> 


-- 
Matt Benjamin
The Linux Box
206 South Fifth Ave. Suite 150
Ann Arbor, MI  48104

http://linuxbox.com

tel.  734-761-4689 
fax.  734-769-8938 
cel.  734-216-5309 
