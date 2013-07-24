Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab3GXRDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 13:03:31 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53815 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab3GXRD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 13:03:29 -0400
Message-ID: <51F008DE.50308@wwwdotorg.org>
Date: Wed, 24 Jul 2013 10:03:26 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: balbi@ti.com
CC: Tuomas Tynkkynen <ttynkkynen@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 0/9] Tegra USB cleanup series
References: <1372455427-20898-1-git-send-email-ttynkkynen@nvidia.com> <51D1FCBD.6070104@wwwdotorg.org> <20130724123229.GE17962@radagast>
In-Reply-To: <20130724123229.GE17962@radagast>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 05:32 AM, Felipe Balbi wrote:
> Hi,
> 
> On Mon, Jul 01, 2013 at 04:03:41PM -0600, Stephen Warren wrote:
>> On 06/28/2013 03:36 PM, Tuomas Tynkkynen wrote:
>>> Hi,
>>> 
>>> Here's a few cleanup patches for the Tegra USB drivers, to be
>>> applied on top of Mikko's two patch sets. It mostly deals with
>>> removing all usage of platform data and using standard helpers
>>> and enums instead of Tegra-specific ones.
>> 
>> With the issues in patches 5/9 and 9/9 fixed as I mentioned, this
>> series,
>> 
>> Tested-by: Stephen Warren <swarren@nvidia.com>
> 
> so, do you want me to apply these myself ?

Yes, I believe if all of Tuomas's and Mikko's recent USB patches can
go through one of the USB trees, that would be best. Thanks!

