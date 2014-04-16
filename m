Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272AbaDPARE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 20:17:04 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58719 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaDPARC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 20:17:02 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <534DCBF9.4040505@roeck-us.net>
Date: Tue, 15 Apr 2014 17:16:57 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: David Cohen <david.a.cohen@linux.intel.com>, wim@iguana.be,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
CC: linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        gnomes@lxorguk.ukuu.org.uk
Subject: Re: [PATCH v4.1 2/2] x86: intel-mid: add watchdog platform code for
 Merrifield
References: <1397592366-3899-3-git-send-email-david.a.cohen@linux.intel.com> <1397600432-7243-1-git-send-email-david.a.cohen@linux.intel.com>
In-Reply-To: <1397600432-7243-1-git-send-email-david.a.cohen@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 03:20 PM, David Cohen wrote:
> This patch adds platform code for Intel Merrifield.
> Since the watchdog is not part of SFI table, we have no other option but
> to manually register watchdog's platform device (argh!).
>
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

