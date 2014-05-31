Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935108AbaEaDBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 23:01:00 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:58486 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935069AbaEaDA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 23:00:58 -0400
Date: Fri, 30 May 2014 23:00:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sune =?iso-8859-1?Q?M=F8lgaard?= <sune@molgaard.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org
Subject: Re: [RFC] Summarizing deprecations
Message-ID: <20140531030055.GA8362@home.goodmis.org>
References: <53893895.3040202@molgaard.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53893895.3040202@molgaard.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2014 at 04:04:05AM +0200, Sune Mølgaard wrote:
> 
> As a user first, and only secondly a developer, I'd like my HW to work,
> and finding fully supported gear can still be hard if not impossible,
> but I imagine that if we had a central place to list deprecations (and,
> possibly, "victims" of them), a lot of grief could be avoided by simply
> pointing vendors to that central resource and saying "here is what you
> need to know for your driver to keep working - now get to it".

We had that. It was in the Documentation directory called "feature-removal.txt".
But that was always out of date and caused lots of unnecessary conflicts
by the few that added stuff to it that it became more of a pain to have than
it was worth. And commit 9c0ece069b32e8e122aea71aa47181c10eb85ba7 nuked it.

-- Steve

