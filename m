Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457AbaAXSmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 13:42:53 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35532 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaAXSmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 13:42:52 -0500
MIME-Version: 1.0
In-Reply-To: <1390504562-20333-1-git-send-email-curt@cumulusnetworks.com>
References: <1390504562-20333-1-git-send-email-curt@cumulusnetworks.com>
Date: Fri, 24 Jan 2014 18:42:51 +0000
X-Google-Sender-Auth: UNBrquiXX0xsgvmHCJWSGbSIuR4
Message-ID: <CAOMwXhMfd8uw8n2Oa_BKW8UGzrUttD1L3=ATUGyDJMFy3kPUjQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] Create eeprom_dev hardware class for EEPROM devices
From: Laszlo Papp <lpapp@kde.org>
To: Curt Brune <curt@cumulusnetworks.com>
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Thomas De Schampheleire <patrickdepinguin@gmail.com>,
        gregkh@linuxfoundation.org,
        Shrijeet Mukherjee <shm@cumulusnetworks.com>,
        linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Note: The class cannot be called 'eeprom' as that is the name of the
> I/O file created by the driver.  The class name appears as a
> sub-directory within the main device directory.  Hence the class name
> 'eeprom_dev'.

I am not sure I follow the reasoning here, but it is possibly because
I lack some knowledge. Could you please describe bad thing would
happen if "/sys/class/eeprom/eeprom0/label" would be used as opposed
to "/sys/class/eeprom_dev/eeprom0/label"?
