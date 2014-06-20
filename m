Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934395AbaFTE7b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 00:59:31 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:60379 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbaFTE73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 00:59:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAJe_ZhcSMrN6OeRjo7cG7CMobjEPMMB7o0eUD9HAFskravSQ3w@mail.gmail.com>
References: <1402944372-31901-1-git-send-email-bjorn.andersson@sonymobile.com>
	<7hvbrzbh1u.fsf@paris.lan>
	<CAJAp7OhHr4Cgcp9pvQ3=MAie_zSnFJxG28Vf37qJ98BK7P1jaQ@mail.gmail.com>
	<7hzjha8b97.fsf@paris.lan>
	<842A7147-A2CC-42BD-9947-CBADF738DC92@codeaurora.org>
	<7hegym6uca.fsf@paris.lan>
	<CAJe_ZhfmsgvnVu-VgN63LaZ-522HuAY_EVfB6ujQjdzBE+u=zA@mail.gmail.com>
	<CAJAp7OgfsVs9C0RNrDnQ5g7heba7JjaYFrj7wVUqT_m+wu-A3A@mail.gmail.com>
	<CAJe_ZhcSMrN6OeRjo7cG7CMobjEPMMB7o0eUD9HAFskravSQ3w@mail.gmail.com>
Date: Thu, 19 Jun 2014 21:59:28 -0700
Message-ID: <CAJAp7OgXDYh1VEZ43UBbs8L-d2P-7ub0Yg3s73BcqC6ekzEBJQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] Qualcomm Resource Power Manager driver
From: Bjorn Andersson <bjorn@kryo.se>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: Kevin Hilman <khilman@linaro.org>, Kumar Gala <galak@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Paul Walmsley <paul@pwsan.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 1:01 PM, Jassi Brar <jaswinder.singh@linaro.org> wrote:
[...]
> Mailbox isn't about how you program the h/w. Do whatever is needed to
> send a message across.
>

But there are no messages to get across here, each individual resource
is exposed directly in the address space of the Linux system.

> BTW I haven't looked closely, but probably you could push the data tables in DT?
>

The first RFC for this had all configuration in devicetree; we decided
not to go that path as this gave a cleaner abstraction and is less
error prone.

Regards,
Bjorn
