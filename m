Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbaCMLng (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 07:43:36 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:47743 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbaCMLnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 07:43:35 -0400
MIME-Version: 1.0
Date: Thu, 13 Mar 2014 17:13:34 +0530
Message-ID: <CAOAoqGt_Y_weA2FjA8x-NrZS7zj+=Zw-TH5Xv+QUQDJQixmdsw@mail.gmail.com>
Subject: Check if usb device is suspended
From: Jagdish Gedia <jvgediya@gmail.com>
To: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I want to check in my driver if usb device is suspended or not?
currently i am doing it like

if(udev->state==USB_STATE_SUSPENDED)

Is this the proper way? Is this enough?










Thanks,
Jagdish Gediya
