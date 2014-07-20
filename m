Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750895AbaGTEDR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 00:03:17 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:44006 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaGTEDQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 00:03:16 -0400
MIME-Version: 1.0
Date: Sun, 20 Jul 2014 00:03:15 -0400
Message-ID: <CAPDOMVh9knmN1y-LZWvsAKcrKKPQsi0+skNG1D0aQgP+hg3ssQ@mail.gmail.com>
Subject: Arm Build Failing
From: Nick Krause <xerofoify@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arm-linux-gnueabihf-gcc: error: unrecognized command line option ‘-m64’
arm-linux-gnueabihf-gcc: error: unrecognized command line option ‘-mno-mmx’
arm-linux-gnueabihf-gcc: error: unrecognized command line option ‘-mno-sse’
arm-linux-gnueabihf-gcc: error: unrecognized command line option ‘-mno-red-zone’
arm-linux-gnueabihf-gcc: error: unrecognized command line option
‘-mcmodel=kernel’
This happens every time I try to build new arch code this week. Is there a easy
fix for this?
Cheers Nick
