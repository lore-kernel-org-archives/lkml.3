Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab3GWK52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 06:57:28 -0400
Received: from mga14.intel.com ([143.182.124.37]:19473 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649Ab3GWK50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 06:57:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,726,1367996400"; 
   d="scan'208";a="335473973"
Message-ID: <51EE6191.3050202@intel.com>
Date: Tue, 23 Jul 2013 12:57:21 +0200
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Luis Henriques <luis.henriques@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lan Tianyu <tianyu.lan@intel.com>
Subject: Re: [ 10/18] ACPI / EC: Add HP Folio 13 to ec_dmi_table in order
 to skip DSDT scan
References: <20130719021048.965829361@linuxfoundation.org>  <20130719021049.669930750@linuxfoundation.org>  <87txjm609i.fsf@canonical.com> <1374553313.16248.68.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1374553313.16248.68.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6NAvW0G018070

On 7/23/2013 6:21 AM, Ben Hutchings wrote:
> On Mon, 2013-07-22 at 17:13 +0100, Luis Henriques wrote:
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>>
>>> 3.0-stable review patch.  If anyone has any objections, please let me know.
>> Sorry for the late review, but this patch is actually tagged for
>> stable kernels >= 3.9 ("Cc: 3.9+ <stable@vger.kernel.org>").  But it
>> is probably harmless and not worth the trouble of reverting them from
>> 3.0 and 3.4.
> I don't think it does any good without the preceding fix (commit
> 2fa97feb4406c546b52e35b6b6c50cb8f63425d2) which unfortunately requires
> 3.9.  I don't know whether it will make things any worse.

These fixes should only go together.

Thanks,
Rafael

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
