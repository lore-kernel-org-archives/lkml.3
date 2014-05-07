Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889AbaEGHQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 03:16:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbaEGHQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 03:16:58 -0400
Date: Wed, 7 May 2014 09:16:55 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] coretemp.0 folder contents changed
Message-ID: <20140507091655.3d5e1fc7@endymion.delvare>
In-Reply-To: <5368FDB6.3000107@linux.intel.com>
References: <5367C6A7.5020008@linux.intel.com>
	<20140505173231.GA25644@roeck-us.net>
	<20140506135558.3cafd062@endymion.delvare>
	<5368FDB6.3000107@linux.intel.com>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 May 2014 08:20:22 -0700, Srinivas Pandruvada wrote:
> I maintain thermal daemon, which was using the path. So once Ubuntu 
> upgrade kernel,
> this will break. So I have to make sure that corresponding user space 
> change is submitted.
> I don't want to depend on too many libraries as it also runs on many 
> embedded platforms
> where many library pre-builts don't exists.
> (...)
> Also when using Android like platform with limited library support,
> we have to make sure that libsensor exists.

libsensors is small, fast and portable. There's really no excuse for
not using it if your daemon is written in C or C++.

-- 
Jean Delvare
SUSE L3 Support
