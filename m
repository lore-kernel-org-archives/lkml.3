Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbaHZTuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 15:50:11 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:55379 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbaHZTuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 15:50:09 -0400
Message-ID: <53FCE4ED.30300@kernel.org>
Date: Tue, 26 Aug 2014 20:50:05 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Daniel Baluta <daniel.baluta@intel.com>, linux-iio@vger.kernel.org
CC: srinivas.pandruvada@linux.intel.com, pmeerw@pmeerw.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] io: accel: kxcjk1013: Remove redundant assignment
References: <1408692956-11379-1-git-send-email-daniel.baluta@intel.com>
In-Reply-To: <1408692956-11379-1-git-send-email-daniel.baluta@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/08/14 08:35, Daniel Baluta wrote:
> data->range is already set by kxcjk1013_set_range.
> 
> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
Applied to the togreg branch of iio.git.  Initially pushed out as testing
for the autobuilders to play.

Thanks,

Jonathan
> ---
>  drivers/iio/accel/kxcjk-1013.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
> index 70a5679..01e86d0 100644
> --- a/drivers/iio/accel/kxcjk-1013.c
> +++ b/drivers/iio/accel/kxcjk-1013.c
> @@ -239,9 +239,6 @@ static int kxcjk1013_chip_init(struct kxcjk1013_data *data)
>  	if (ret < 0)
>  		return ret;
>  
> -	data->range = KXCJK1013_RANGE_4G;
> -
> -
>  	ret = i2c_smbus_read_byte_data(data->client, KXCJK1013_REG_DATA_CTRL);
>  	if (ret < 0) {
>  		dev_err(&data->client->dev, "Error reading reg_data_ctrl\n");
> 
