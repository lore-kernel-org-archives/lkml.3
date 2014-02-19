Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbaBSLzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 06:55:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454AbaBSLzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 06:55:09 -0500
Message-ID: <53049B7A.6080404@redhat.com>
Date: Wed, 19 Feb 2014 12:54:34 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Lee Jones <lee.jones@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alexandre.torgue@st.com, linux-ide@vger.kernel.org
Subject: Re: [PATCH 3/3] ahci: st: Add support for ST's SATA IP
References: <1392641818-23419-1-git-send-email-lee.jones@linaro.org> <1392641818-23419-3-git-send-email-lee.jones@linaro.org> <20140218233645.GP31892@mtj.dyndns.org>
In-Reply-To: <20140218233645.GP31892@mtj.dyndns.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02/19/2014 12:36 AM, Tejun Heo wrote:
> On Mon, Feb 17, 2014 at 12:56:58PM +0000, Lee Jones wrote:
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: linux-ide@vger.kernel.org
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Please consider basing it on top of Hans' refactored ahci_platform.
> 
>  http://www.spinics.net/lists/linux-ide/msg47628.html

Which reminds I must test the version I've rebased on top of 3.14-rc1
and then send a v6 so that this can get merged.

Lee, I'll add you to the CC of the v6 I'm about to send.

Regards,

Hans
