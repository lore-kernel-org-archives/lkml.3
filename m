Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaEZRtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:49:25 -0400
Received: from 1wt.eu ([62.212.114.60]:36040 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbaEZRtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 13:49:24 -0400
Date: Mon, 26 May 2014 19:49:17 +0200
From: Willy Tarreau <w@1wt.eu>
To: Joe Perches <joe@perches.com>
Cc: Dominique van den Broeck <domdevlin@free.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: panel: (coding style) Matching braces
Message-ID: <20140526174917.GK13929@1wt.eu>
References: <1400674201-9560-1-git-send-email-domdevlin@free.fr> <20140526142827.GG13929@1wt.eu> <1401125290.519.18.camel@joe-AO725>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401125290.519.18.camel@joe-AO725>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 10:28:10AM -0700, Joe Perches wrote:
> On Mon, 2014-05-26 at 16:28 +0200, Willy Tarreau wrote:
> > I believe that most of the kernel code prefers the two-line format resluting
> > in this instead :
> > 
> > 		}
> > 		else if (*esc >= 'A' && *esc <= 'Z') {
> > 			value |= (*esc - 'A' + 10) << shift;
> > 		}
> > 		else if (*esc >= 'a' && *esc <= 'z') {
> > 			value |= (*esc - 'a' + 10) << shift;
> > 		}
> > 		else {
> 
> grep shows what kernel style is most used.
> 
> Your form:
> 	}
> 	else if (...) {
> 
> (This shows 3 lines per instance)
> $ grep-2.5.4 -rP --include=*.[ch] '}\n[ \t]*else if.*{\n' * | wc -l
> 909
> 
> Generally used form:
> 	} else if (...) {
> 
> (mostly shows 2 lines per instance)
> $ grep-2.5.4 -rP --include=*.[ch] '} else if.*{\n' * | wc -l
> 31653
> 
> That's ~50:1 preference for "} else if (...) {"

Ah indeed, I wouldn't have thought that. Thanks for correcting me, Joe!

Willy

