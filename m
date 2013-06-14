Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab3FNNEG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 09:04:06 -0400
Received: from service87.mimecast.com ([91.220.42.44]:53450 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab3FNNEE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 09:04:04 -0400
Message-ID: <1371215040.3154.6.camel@hornet>
Subject: Re: [RFC PATCH v3 2/2] drivers: mfd: vexpress: add Serial Power
 Controller (SPC) support
From: Pawel Moll <pawel.moll@arm.com>
To: Olof Johansson <olof@lixom.net>
Cc: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Jon Medhurst <tixy@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Achin Gupta <Achin.Gupta@arm.com>,
        Amit Kucheria <amit.kucheria@linaro.org>
Date: Fri, 14 Jun 2013 14:04:00 +0100
In-Reply-To: <20130613225233.GB22310@quad.lixom.net>
References: <1370512763-32200-1-git-send-email-lorenzo.pieralisi@arm.com>
	 <1370512763-32200-3-git-send-email-lorenzo.pieralisi@arm.com>
	 <20130613225233.GB22310@quad.lixom.net>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 14 Jun 2013 13:04:01.0601 (UTC) FILETIME=[A3E5AB10:01CE68FF]
X-MC-Unique: 113061414040102301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-13 at 23:52 +0100, Olof Johansson wrote:
> > +     reg = <0 0x7FFF0000 0 0x1000>;
> 
> #size-cells 2 on the parent bus? That's somewhat unusual. 

LPAE == 40 bit physical addresses == potential > 32 bit sizes (memory
blocks > 4GB)

Paweł


