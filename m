Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbaBUSHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 13:07:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36974 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754055AbaBUSHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 13:07:36 -0500
Message-ID: <530795E0.7080602@redhat.com>
Date: Fri, 21 Feb 2014 19:07:28 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Liu, Jinsong" <jinsong.liu@intel.com>
CC: "gleb@redhat.com" <gleb@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: Re: [PATCH v4 3/3] KVM: x86: Enable Intel MPX for guest
References: <DE8DF0795D48FD4CA783C40EC829233501509C2B@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC829233501509C2B@SHSMSX101.ccr.corp.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/02/2014 18:57, Liu, Jinsong ha scritto:
> -		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | F(RDSEED) |
> +		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | F(MPX) | F(RDSEED) |
>  		F(ADX);

MPX also needs to be conditional on mpx_supported here, like it is done 
with f_rdtscp for example.

Paolo
