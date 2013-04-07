Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933403Ab3DGL25 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 07:28:57 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:36980 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932381Ab3DGL24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 07:28:56 -0400
Date: Sun, 7 Apr 2013 11:28:55 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-man@vger.kernel.org
Subject: Re: net_dropmon usage documentation/examples?
Message-ID: <20130407112855.GA2544@dcvr.yhbt.net>
References: <20130405193855.GA27775@dcvr.yhbt.net>
 <20130406123856.GA11355@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130406123856.GA11355@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman <nhorman@tuxdriver.com> wrote:
> On Fri, Apr 05, 2013 at 07:38:55PM +0000, Eric Wong wrote:
> > Hi Neil, I'm wondering if you have or know of any public
> > documentation/examples for using net_dropmon.
> > 
> > If not, I'll figure it out on my own at some point.
> > 
> > Thanks in advance!
> 
> I don't think there are any particular examples at the moment, but if you
> download the dropwatch utility, it uses the dropmon protocol to detect frame
> loss in the stack, and its use is pretty self explanitory, as is the perf script
> that uses the same tracepoints as the dropmon protocol.
> 
> 
> https://fedorahosted.org/dropwatch/

Thanks Neil!  I think I'll just use dropwatch directly instead of
writing my own code, now :)
