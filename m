Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab3FQX3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:29:53 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:36323 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab3FQX3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:29:51 -0400
Date: Tue, 18 Jun 2013 01:29:02 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, juan.david.gonzalez.cobas@cern.ch,
        cota@braap.org, siglesias@igalia.com, rob@landley.net,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/8] FMC: add needed headers
Message-ID: <20130617232902.GA17234@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
In-Reply-To: <20130617232120.GF12984@kroah.com>
References: <20130617232120.GF12984@kroah.com>
  <cover.1371018406.git.rubini@gnudd.com>
  <1d3aedf8636f4bed4ffda25e13acd853bf8e08fb.1371018406.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Any way you can use MODULE_DEVICE_TABLE() for these devices to get
> proper module auto-loading for your drivers?

It's the next step.

We are not doing that in our installations because it is not a trivial
addition to running kernels -- we are plugging FMC devices in
already-deployed kernel versions, sometimes even 2.6.24.

/alessandro
