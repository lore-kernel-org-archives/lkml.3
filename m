Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbaE0DU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 23:20:59 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:61498 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbaE0DU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 23:20:57 -0400
From: Reyad Attiyat <reyad.attiyat@gmail.com>
To: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        srinivas.pandruvada@linux.intel.com, jic23@kernel.org
Cc: Reyad Attiyat <reyad.attiyat@gmail.com>
Subject: [PATCH] IIO: Support for True/Magnetic north
Date: Mon, 26 May 2014 22:20:20 -0500
Message-Id: <1401160821-5006-1-git-send-email-reyad.attiyat@gmail.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <538076CA.6050809@kernel.org>
References: <538076CA.6050809@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jonathan and Srinivas,

I have added in the needed magn_north iio sysfs attributes to the documentation.
I hope I did everything correct.
I noticed that the line length was very long as compensated is a  fairly long word. 
I'm thinking I could shorten some of the sysfs paths or shorten the name.

For updating the hid-sensor-magn-3d do you have any tips on this? I'm thinking I'll need a 
dynamic iio_chan array that is passed to iio_register function. It would need to 
be dynamic in the sense it would only add channels if it found x, y, z, or one of  
the north attributes. I'll start working on this soon.

Thank You,
Reyad Attiyat



Reyad Attiyat (1):
  IIO: Added iio magn_north ABI documentation

 Documentation/ABI/testing/sysfs-bus-iio | 76 +++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

-- 
1.9.0

