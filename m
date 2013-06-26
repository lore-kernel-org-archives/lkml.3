Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab3FZKXs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 06:23:48 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:54103 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab3FZKXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 06:23:47 -0400
Message-ID: <51CAC127.8070106@linux.vnet.ibm.com>
Date: Wed, 26 Jun 2013 15:53:35 +0530
From: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tony Luck <tony.luck@gmail.com>
CC: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>, ananth@in.ibm.com,
        mahesh@linux.vnet.ibm.com, Anton Vorontsov <cbouatmailru@gmail.com>,
        Colin Cross <ccross@android.com>
Subject: Re: [PATCH v2] pstore: Fail to unlink if a driver has not defined
 pstore_erase
References: <20130625090253.26584.65072.stgit@aruna-ThinkPad-T420> <CAGXu5jKSMtaLsTGYqpxnEM-dW+99SYhE1+SzLsD3gngxhxYN7w@mail.gmail.com> <CA+8MBbJ5Fa_q0_iS34g+5A5ghm087feODsCgMUJZJAGWTo_ZPg@mail.gmail.com>
In-Reply-To: <CA+8MBbJ5Fa_q0_iS34g+5A5ghm087feODsCgMUJZJAGWTo_ZPg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062610-5564-0000-0000-00000887DE0D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 June 2013 10:40 PM, Tony Luck wrote:
> On Tue, Jun 25, 2013 at 9:41 AM, Kees Cook <keescook@chromium.org> wrote:
>> On Tue, Jun 25, 2013 at 2:03 AM, Aruna Balakrishnaiah
>> <aruna@linux.vnet.ibm.com> wrote:
>>> pstore_erase is used to erase the record from the persistent store.
>>> So if a driver has not defined pstore_erase callback return
> How do people manage devices like this?  With no erase function
> they just keep getting more and more pstore entries. Eventually
> they fill up.

We dont keep old records in the device. We have logs only of the
recent / last crash.  The device has a predefined space for each type
of messages.  For example:  Every time a crash occurs the data gets
overwritten in the device allocated to store crash log.

>
>>> Signed-off-by: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
>> Acked-by: Kees Cook <keescook@chromium.org>
> Applied - thanks.
>
> -Tony
>

