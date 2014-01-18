Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaARTuG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 14:50:06 -0500
Received: from plane.gmane.org ([80.91.229.3]:55128 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347AbaARTuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 14:50:03 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?= 
	<holger.hoffstaette@googlemail.com>
Subject: Re: 3.12.8 poor network performance x86_64
Date: Sat, 18 Jan 2014 19:49:38 +0000 (UTC)
Message-ID: <pan.2014.01.18.19.49.51@googlemail.com>
References: <52DAD66F.7080306@dragonslave.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p5b006344.dip0.t-ipconnect.de
User-Agent: Pan/0.139 (Sexual Chocolate; GIT bf56508
 git://git.gnome.org/pan2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Jan 2014 20:30:55 +0100, Daniel Exner wrote:

> I recently upgraded the Kernel from version 3.10 to latest stable
> 3.12.8, did the usual "make oldconfig" (resulting config attached).
> 
> But now I noticed some _really_ low network performance.

Try: sysctl net.ipv4.tcp_limit_output_bytes=262144

Holger

