Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaFOTyJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 15:54:09 -0400
Received: from mail.kernel.org ([198.145.19.201]:39460 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbaFOTyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 15:54:05 -0400
Message-ID: <539DFA4E.5030203@kernel.org>
Date: Sun, 15 Jun 2014 20:55:58 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Support Opensource <Support.Opensource@diasemi.com>
Subject: Re: [PATCH 4/8] iio: Add support for DA9150 GPADC
References: <cover.1402484954.git.Adam.Thomson.Opensource@diasemi.com> <3c1a7551c7deaeccdca731fa95f4349c57e04249.1402484954.git.Adam.Thomson.Opensource@diasemi.com> <ba29cc7f-7586-430c-8947-763510e04212@email.android.com> <2E89032DDAA8B9408CB92943514A0337A56F5455@SW-EX-MBX01.diasemi.com>
In-Reply-To: <2E89032DDAA8B9408CB92943514A0337A56F5455@SW-EX-MBX01.diasemi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/14 17:56, Opensource [Adam Thomson] wrote:
> On June 11, 2014 17:35, Jonathon Cameron wrote:
>
>> Hi Adam. Silly question but what are the _ channels?
>>
>> I have put in a perhaps optimistic data sheet request via the website, throwing in
>> your name. Hope you don't mind!
>>
>> Jonathan
>
> Hi Jonathon. Some of the _channels are a different representation of the reading
> (e.g. different scale - one would be 0-6V range, and one would be 0-21V for
> example).
Why? That is, why present the data twice with the different scales?


> Others provide identical readings to the non _channel but have left
> those in to keep the channel numbering sane and easy to reference.
If there is a reason to support this functionality, this is not a sensible
way to do it!
>
> No problem regarding the request.
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{��*"��^n�r���z���h����&���G���h�(�階�ݢj"���m�����z�ޖ���f���h���~�mml==
>

