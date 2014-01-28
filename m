Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbaA1Rge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 12:36:34 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:54142 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbaA1Rgd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 12:36:33 -0500
MIME-Version: 1.0
In-Reply-To: <20140128104503.GG11841@sirena.org.uk>
References: <1390878720-8676-1-git-send-email-badarkhe.manish@gmail.com>
	<10462793.IYoAK2XtXv@phil>
	<CAKDJKT4jPLmtrm6Ngp+nT5vf0H4zXwwAM=oURDF-DSAJodVN6A@mail.gmail.com>
	<1939430.3DVPas1i8V@phil>
	<CAKDJKT5z=-CmK+goocgdqy2eQMZN2tsoPgzOFk4KbFTTTiUNAA@mail.gmail.com>
	<20140128104503.GG11841@sirena.org.uk>
Date: Tue, 28 Jan 2014 23:06:32 +0530
Message-ID: <CAKDJKT7a4j=vw3gwqus=TdnxPYnubAsWh3ThH_t3-ABj6b0B9A@mail.gmail.com>
Subject: Re: [PATCH V2] regulator: fixed: update to devm_* API
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Jan 28, 2014 at 4:15 PM, Mark Brown <broonie@kernel.org> wrote:
> On Tue, Jan 28, 2014 at 02:31:32PM +0530, Manish Badarkhe wrote:
>> On Tue, Jan 28, 2014 at 2:25 PM, Heiko Stübner <heiko@sntech.de> wrote:
>
>> > I don't have a strong opinion on this and others are most likely more qualified
>> > to have a definitive answer, I just found it strange to exchange one open-coded
>> > pattern against another open-coded one.
>> >
>> > So don't let me keep you from it ;-)
>
>> Okay.
>> @Mark, Dmitry: Please let me know your opinion on this.
>
> How about implementing devm_kstrdup() and then using that?

Okay, I will update kstrdup()->devm_kstrdup() and post next version of patch.

Thanks
Manish Badarkhe
