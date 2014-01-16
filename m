Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751775AbaAPUO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 15:14:27 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33718 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbaAPUOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 15:14:23 -0500
MIME-Version: 1.0
In-Reply-To: <20140116195115.GD4127@katana>
References: <1382326010-4554-1-git-send-email-bleung@chromium.org>
	<1382326010-4554-3-git-send-email-bleung@chromium.org>
	<20131021065804.GX3521@intel.com>
	<CANLzEksGqD30Cefh3r2urH-ToxWzkxAnTJZiY07yX2Py58FQPw@mail.gmail.com>
	<20131114180538.GK11022@katana>
	<CANLzEksP1nRfBaQ3-sSouOYL4C+oLKiE75eHfFdEzLmrQKn3dQ@mail.gmail.com>
	<20131126130959.GI7427@katana>
	<20140103155217.GG7132@katana>
	<CANLzEkvgYQtkEyOMNpPcS9BeYzX3zJn7hvtsyhFzbDpViS8-2Q@mail.gmail.com>
	<20140116195115.GD4127@katana>
Date: Thu, 16 Jan 2014 12:14:22 -0800
X-Google-Sender-Auth: QpVmCAuwqf0zvPM-np31o1LDd_o
Message-ID: <CANLzEksAQmzTCTTm-Tx198i7+sDmast5Lcn6fvYZddwNbwvLkQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] i2c-designware-pci: Index Haswell ULT bus names from 0
From: Benson Leung <bleung@chromium.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>, khali@linux-fr.org,
        andriy.shevchenko@linux.intel.com, jacmet@sunsite.dk,
        linux-i2c@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Duncan Laurie <dlaurie@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

On Thu, Jan 16, 2014 at 11:51 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
>
> > Our devices and our platforms have some other requirements which
> > turned me away from using i2c_register_board_info.
>
> Okay, so I'll drop these patches.


Sorry if I was unclear, but I am not able to use
i2c_register_board_info for these devices because of the requirement
to use "probe."

Currently, I am doing explicit instantiation of devices using
i2c_new_probed_device.


-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
