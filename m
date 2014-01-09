Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbaAILJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 06:09:06 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:34122 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbaAILI7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 06:08:59 -0500
Date: Thu, 9 Jan 2014 11:56:51 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/28] drm/i2c: tda998x: add DT support and other
 improvements
Message-ID: <20140109115651.482e2db1@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set contains various extensions to the tda998x driver:

- simplify the i2c read/write
- code cleanup and fix some small errors
- use HDMI constants
- don't read write-only registers
- add DT support
- use irq for connection status and EDID read
- get a better status of the HDMI connector
- use the tda998x video format when cea mode
- add tda998x codec interface

- v2
	- decompose patches with different topics
	- fix some bad i2c register values
	- add audio codec interface

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
