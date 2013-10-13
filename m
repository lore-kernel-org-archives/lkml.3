Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab3JMLrD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 07:47:03 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:43941 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289Ab3JMLq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 07:46:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=Cv4Hze
	BbJ4R9AlMGdhSd5cHYGOFOHCHmOpOC1DWwejyO+slY33JsjkTEnYa3LUqaCx5Ph5
	KxnjDbkQ6glxftyjrDH9IBot+o80xDRtw6pH7MQUOwF1GDz6M7mRvI6jfIjfMvUM
	dFhJ742/P5MSj7Rvruvqc5YHkMTggJkOnzpdQ=
Message-ID: <525A882C.3030905@pobox.com>
Date: Sun, 13 Oct 2013 20:46:52 +0900
From: Shinya Kuribayashi <skuribay@pobox.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: mika.westerberg@linux.intel.com, Romain.Baeriswyl@abilis.com
CC: wsa@the-dreams.de, rob.herring@calxeda.com, pawel.moll@arm.com,
        mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net,
        pierrick.hascoet@abilis.com, vgupta@synopsys.com,
        christian.ruppert@abilis.com, chiau.ee.chew@intel.com,
        khali@linux-fr.org, rafael.j.wysocki@intel.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        romainba@abilis.com
Subject: Re: [PATCH 2/2] i2c designware add support of I2C standard mode
References: <20130828153429.GB7066@ab42.lan> <1381244455-3836-2-git-send-email-romainba@abilis.com> <20131009075632.GR3521@intel.com>
In-Reply-To: <20131009075632.GR3521@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 2A90FFD4-33FD-11E3-A25A-8F264F2CC097-47602734!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/9/13 4:56 PM, Mika Westerberg wrote:> On Tue, Oct 08, 2013 at 05:00:55PM +0200, Romain Baeriswyl wrote:
>> Some legacy devices support ony I2C standard mode at 100kHz.
>> This patch allows to select the standard mode through the DTS
>> with the use of the existing clock-frequency parameter.
>>
>> When clock-frequency parameter is not set, the fast mode is selected.
>> Only when the parameter is set at 100000, the standard mode is selected.
>>
>> Signed-off-by: Romain Baeriswyl <romainba@abilis.com>
>> Reviewed-by: Christian Ruppert <christian.ruppert@abilis.com>
>
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>

I don't have build environment for these patches right now, but both
changes 1/2 and 2/2 look good.

It's quite reasonable and makes the code readable to convert
{3 => 300} into nsec based one.  I should have done so from the
beginning, thanks for doing this.

   Shinya

