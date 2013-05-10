Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741Ab3EJKyj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 06:54:39 -0400
Received: from plane.gmane.org ([80.91.229.3]:45452 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750867Ab3EJKyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 06:54:38 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Holger Hoffstaette" <holger.hoffstaette@googlemail.com>
Subject: Re: [ 00/73] 3.8.13-stable review
Date: Fri, 10 May 2013 12:54:27 +0200
Organization: The Fists of the White Lotus
Message-ID: <pan.2013.05.10.10.54.26.943195@googlemail.com>
References: <20130509222757.917088509@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p5086a710.dip0.t-ipconnect.de
User-Agent: Pan/0.13.91 (Before we let euphoria convince us we are free)
Cc: stable@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 May 2013 15:31:23 -0700, Greg Kroah-Hartman wrote:

> This is the start of the stable review cycle for the 3.8.13 release. There

This patchset broke my internet, with all sorts of weird effects like
Samba clients having problems to talk to the server and only partially
working DNS resolution (CDNs broken, Amazon unreachable).

After two reboots to/from .12/.13 (to rule out temporary internet
brokenness) the problem has been identified as:

> Stefan Bader <stefan.bader@canonical.com>
>     r8169: fix 8168evl frame padding.

After reverting only this patch (turning r8169 back to 3.8.12) things
again behave as expected with the rest of .13. So far no other regressions
detected.

This patch should probably be removed from 3.9.2-rc as well.

-h


