Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965779AbaFSV4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:56:34 -0400
Received: from www.linutronix.de ([62.245.132.108]:55852 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965317AbaFSV4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:56:32 -0400
Message-Id: <20140619215347.139324048@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 19 Jun 2014 21:56:28 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Viresh Kumar <viresh.linux@gmail.com>, spear-devel@list.st.com
Subject: [patch 0/2] dt: spear320: Make it work
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sdhci compatible does neither match the documentation nor the
implementaion in the drivers and the i2c1 is missing an interrupt
assignment.

Thanks,

	tglx


