Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbaELJrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:47:53 -0400
Received: from bay0-omc3-s21.bay0.hotmail.com ([65.54.190.159]:54409 "EHLO
	bay0-omc3-s21.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755050AbaELJrr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:47:47 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 May 2014 05:47:47 EDT
X-TMN: [PZo8VZR8CO8RiLn45UNd/1tQif2t197E]
X-Originating-Email: [pintu.k@outlook.com]
Message-ID: <BAY169-W12541AD089785F8BFBD4E26EF350@phx.gbl>
From: Pintu Kumar <pintu.k@outlook.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>
Subject: Questions regarding DMA buffer sharing using IOMMU
Date: Mon, 12 May 2014 15:12:41 +0530
Importance: Normal
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 12 May 2014 09:42:41.0643 (UTC) FILETIME=[84D35BB0:01CF6DC6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 
I have some queries regarding IOMMU and CMA buffer sharing. 
We have an embedded linux device (kernel 3.10, RAM: 256Mb) in which camera and codec supports IOMMU but the display does not support IOMMU. 
Thus for camera capture we are using iommu buffers using ION/DMABUF. But for all display rendering we are using CMA buffers. 
So, the question is how to achieve buffer sharing (zero-copy) between Camera and Display using only IOMMU? 
Currently we are achieving zero-copy using CMA. And we are exploring options to use IOMMU. 
Now we wanted to know which option is better? To use IOMMU or CMA? 
If anybody have come across these design please share your thoughts and results. 


Thank You! 
Regards, 
Pintu

 		 	   		  