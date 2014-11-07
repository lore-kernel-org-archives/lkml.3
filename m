Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbaKGTd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 14:33:56 -0500
Received: from smtp-out-036.synserver.de ([212.40.185.36]:1063 "EHLO
	smtp-out-036.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbaKGTdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 14:33:55 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 24192
Message-ID: <545D1EC3.30901@metafoo.de>
Date: Fri, 07 Nov 2014 20:34:27 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Joshua Lamorie <joshua.lamorie@xiphos.com>
CC: Jonathan Cameron <jic23@kernel.org>, michal.simek@xilinx.com,
        linux-iio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, soren.brinkmann@xilinx.com,
        Fabien Proriol <Fabien.Proriol@jdsu.com>
Subject: Re: [PATCH] iio:xilinx-xadc:xadc_read_raw INFO_OFFSET
References: <1415387516-15051-1-git-send-email-joshua.lamorie@xiphos.com>
In-Reply-To: <1415387516-15051-1-git-send-email-joshua.lamorie@xiphos.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2014 08:11 PM, Joshua Lamorie wrote:
> Added a condition for a read of IIO_CHAN_INFO_OFFSET to
> ensure that an offset is only provided for requests for XADC temperature. The
> previous assumption was that only requests for temperature would include a
> read of CHAN_INFO_OFFSET. However there is no way to restrict this in calling
> functions, such as iio_convert_raw_to_processed_unlocked() which is called when
> using the XADC as a device for iio_hwmon.

Fabien send pretty much the same patch yesterday. See 
http://thread.gmane.org/gmane.linux.kernel.iio/14579

- Lars
