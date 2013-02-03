Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab3BCNBv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 08:01:51 -0500
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:41658 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab3BCNBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 08:01:49 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah5lAIRfDlFV5qjOPGdsb2JhbABEhV+FILMvBIEAFwMBAQEBODSCHwEBBAEnExwjBQsIAyElDwUlChqIHgq/AxWNNoMmYQOWHoYAjU8
X-IronPort-AV: E=Sophos;i="4.84,594,1355094000"; 
   d="scan'208";a="275329901"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sun, 3 Feb 2013 14:07:31 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] Support of Nexio 42" and new default class for
 hid-multitouch
Message-ID: <20130203130731.GA2677@polaris.bitmath.org>
References: <1359649351-11092-1-git-send-email-benjamin.tissoires@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359649351-11092-1-git-send-email-benjamin.tissoires@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> so, this is the v2 of the support of win7/8 devices.

Looks like it is getting there, thanks.

> changes since v1:
> - removed the "optimization" patches, as the benefit was minimum
> - introduce a new callback "report" in hid-core that drivers can use to treat the
>   report by having it entirely parsed
> - rely on this new hook to support Nexio 42"

As noted in the patches comments, using raw_event() seems sufficient.

> side notes:
> - I've tested removing the heavy call to kzalloc in hid_input_field. The results
>   are disapointing -> the processing time remains the same.
> - I've also tested not to rely on .event hook in hid-multitouch but only on .report.
>   Idem, I thought it would reduce the code of hid-multitouch and will enhance its
>   processing time, but the results are a roughly same number of lines for hid-multitouch
>   and the same processing time... :(
> - these 2 tests helped in cleaning the patch set from the last time.
> 
> And again, finally, I've pass all the 40 regression tests of my db. \o/

Nice. :-)

Thanks,
Henrik
