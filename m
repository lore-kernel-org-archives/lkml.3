Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128AbaIPKxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 06:53:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:40281 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046AbaIPKxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 06:53:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,534,1406617200"; 
   d="scan'208";a="477839408"
Date: Tue, 16 Sep 2014 03:53:27 -0700
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "David E. Box" <david.e.box@linux.intel.com>, wsa@the-dreams.de,
        jdelvare@suse.de, arnd@arndb.de, dianders@chromium.org,
        sjg@chromium.org, laurent.pinchart+renesas@ideasonboard.com,
        u.kleine-koenig@pengutronix.de, boris.brezillon@free-electrons.com,
        maxime.coquelin@st.com, max.schwarz@online.de, schwidefsky@de.ibm.com,
        iivanov@mm-sol.com, soren.brinkmann@xilinx.com,
        bjorn.andersson@sonymobile.com, andrew@lunn.ch, skuribay@pobox.com,
        christian.ruppert@abilis.com, Romain.Baeriswyl@abilis.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c-designware: Intel BayTrail PMIC I2C bus support
Message-ID: <20140916035327.4d3d5555@ultegra>
In-Reply-To: <20140916094449.GZ10854@lahna.fi.intel.com>
References: <1410543367-6565-1-git-send-email-david.e.box@linux.intel.com>
	<20140916094449.GZ10854@lahna.fi.intel.com>
Organization: OTC
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2014 12:44:49 +0300
Mika Westerberg <mika.westerberg@linux.intel.com> wrote:

> Is this because we need to access the PMIC from host as well? I mean
> from some PMIC driver (which driver btw)?
> 
This is used by the X-Powers PMIC.
https://lkml.org/lkml/2014/9/11/1016

> Otherwise it would be best to just detect _SEM and return -ENODEV.

Thanks,

Jacob
