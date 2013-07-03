Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab3GCN1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 09:27:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33726 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410Ab3GCN1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 09:27:02 -0400
Message-ID: <51D4269E.4090204@suse.cz>
Date: Wed, 03 Jul 2013 15:26:54 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Nicolas Palix <nicolas.palix@imag.fr>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>, linux-doc@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH v3] coccicheck: span checks across CPUs
References: <20130618214929.GA15976@www.outflux.net> <CAAxaTiMxZV4gLmB6=hm4WBWPj6D+V-g+puU1Gm_E_Zzhm8UEWw@mail.gmail.com>
In-Reply-To: <CAAxaTiMxZV4gLmB6=hm4WBWPj6D+V-g+puU1Gm_E_Zzhm8UEWw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.6.2013 23:51, Nicolas Palix wrote:
> On Tue, Jun 18, 2013 at 11:49 PM, Kees Cook <keescook@chromium.org> wrote:
>> This adds parallelism by default to the "coccicheck" target using
>> spatch's "-max" and "-index" arguments.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> Signed-off-by: Nicolas Palix <nicolas.palix@imag.fr>

Applied to kbuild.git#misc.

Michal

