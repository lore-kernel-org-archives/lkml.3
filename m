Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059Ab3FCJXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:23:49 -0400
Received: from intranet.asianux.com ([58.214.24.6]:40733 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab3FCJXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:23:45 -0400
X-Spam-Score: -100.8
Message-ID: <51AC606C.7060401@asianux.com>
Date: Mon, 03 Jun 2013 17:22:52 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Andreas Schwab <schwab@linux-m68k.org>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v2] arch: m68k: math-emu: unsigned issue, 'unsigned long'
 will never be less than zero
References: <51A6F0C6.9050806@asianux.com> <m2a9ndndu5.fsf@linux-m68k.org> <51A70C10.6000408@asianux.com> <CAMuHMdWOxh_YvQyid-PiN7FsM=OC=0YWOzJb86pKaQn3HrjaQw@mail.gmail.com> <51AC5D7C.2000905@asianux.com> <CAMuHMdXrxAajOqfZd4iQRC2pKHE8KAZOVsZRfeyMWLHRt0NVUg@mail.gmail.com>
In-Reply-To: <CAMuHMdXrxAajOqfZd4iQRC2pKHE8KAZOVsZRfeyMWLHRt0NVUg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2013 05:13 PM, Geert Uytterhoeven wrote:
> On Mon, Jun 3, 2013 at 11:10 AM, Chen Gang <gang.chen@asianux.com> wrote:
>>> >> Thanks, applied and queued for 3.11!
>>> >>
>> >
>> > Thank you too, and pardon: what is '3.11' ?  :-)
> Linux v3.11.

OK, thanks.

-- 
Chen Gang

Asianux Corporation
