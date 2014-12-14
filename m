Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbaLNIwO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 03:52:14 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:38297 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaLNIwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 03:52:12 -0500
MIME-Version: 1.0
Date: Sun, 14 Dec 2014 10:52:10 +0200
Message-ID: <CA+i0qc5MF9_siN05VEOtOdPQfByt1UHEpbwVkYQ5+EObF6H4nQ@mail.gmail.com>
Subject: UFS RPMB
From: Tomas Winkler <tomasw@gmail.com>
To: Vinayak Holikatti <vinholikatti@gmail.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, sorry fore a newbie question.
What is the current interface for accessing rpmb LUN in a UFS devices.
For emmc one need to issue a raw mmc ioctl command  MMC_IOC_CMD.

Thanks
Tomas
