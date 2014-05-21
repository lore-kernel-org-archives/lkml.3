Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbaEUSMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 14:12:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58593 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbaEUSMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 14:12:09 -0400
Date: Wed, 21 May 2014 20:11:45 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Cc: rjw@rjwysocki.net, lenb@kernel.org, tony.luck@intel.com, bp@suse.de,
        m.chehab@samsung.com, linux-edac@vger.kernel.org, x86@kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org
Subject: Re: [PATCH 2/7] acpi, apei, ghes: Introduce more generic mechanism
 to init/deinit GHES error notifications.
Message-ID: <20140521181145.GO21205@pd.tnic>
References: <1397056476-9183-1-git-send-email-tomasz.nowicki@linaro.org>
 <1397056476-9183-3-git-send-email-tomasz.nowicki@linaro.org>
 <20140513181353.GC8760@pd.tnic>
 <5374CFB8.3000107@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5374CFB8.3000107@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 04:31:20PM +0200, Tomasz Nowicki wrote:
> Well, we need to keep these strings somewhere :) IMO, this is simpler
> solution. What would be advantage of additional map function?

Nevermind, I got confused here.

> I am validating generic->notify.type at the begin of function and
> return error in case of unknown value. I think there is no need to
> check that again.

Yes, you do :)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
