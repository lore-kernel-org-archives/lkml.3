Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab3CRNam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 09:30:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56488 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab3CRNaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 09:30:39 -0400
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
Subject: Re: request line field in the generic slave config structure
Date: Mon, 18 Mar 2013 13:30:00 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
References: <1363612546.18714.85.camel@smile>
In-Reply-To: <1363612546.18714.85.camel@smile>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303181330.00610.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:ac2jxSjrWARFedRYFdKc1e+Giev4Ha2uHL1VxTtQO7n
 yxr2tX8EyVQrqZEGCfOPvOAZtru8yEuHx6ZMSvS9C0KuzZKIxq
 l27aEm7Ks4FK49r60/Mgt8BswnhwqKuUc9rbpn4m0vvAIo0W/h
 up60fnAjhdeXxyrFT4w1O8Jm+g7gchOiK54ffbEgP1rzMD3KBw
 FzH7vEpF8wohk7vsQ7OuZ0rET0BXO0glwbQ4gSxW8Erwg9rTuO
 As2tNgtg1roMMy/VUZYSjG06AJJyh90AYdL/uyv5+g4fx3UThT
 m/ZcWjTOs4qFWZ8qvHTG4oTfOwJ8CrjD8GkgIo3zEl6E2dGmEk
 XFm0bEU8EaN7Jq9I4ShCEfGnWXdVuNUYQejvxcq1Y
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 March 2013, Shevchenko, Andriy wrote:
> Hello!
> 
> It seems the one (as I think good) question was left unanswered:
> http://www.spinics.net/lists/arm-kernel/msg186120.html
> 
> What is your opinions, comments?

I'm not sure I understand what the question was. Is this about
whether we should remove the "slave_id" field in the slave
configuration?

Those sort of duplicate the request line information that comes
from the platform in a data structure that should be filled by
the device driver without platform specific knowledge.

I believe that is currently used by shmobile, and we won't be able
to kill that before that platform has been converted to use
dma_request_slave_channel.

	Arnd
