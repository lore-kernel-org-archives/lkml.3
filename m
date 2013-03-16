Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab3CPJGm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 05:06:42 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:63741 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab3CPJGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 05:06:41 -0400
MIME-Version: 1.0
From: Raymond Jennings <shentino@gmail.com>
Date: Sat, 16 Mar 2013 02:06:00 -0700
Message-ID: <CAGDaZ_pHn=ZHJ-cRy5am5w+EYpspfRTKvhmyDCcLVLH=T0Y2Sw@mail.gmail.com>
Subject: block device queues, elevatoring implicit or explicit?
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Are all block devices fundamentally elevators or fifos or what?

To be blunt, if a bunch of concurrent processes dump requests on a
noop queue, are they serviced fifo or in elevator order or what?

My goal is to get a dumb elevator that does nothing but sweep up and
down the disk mopping up outstanding requests as the disk heads ooze
across the sectors.
