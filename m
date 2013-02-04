Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab3BDLsm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:48:42 -0500
Received: from smtprelay-b31.telenor.se ([213.150.131.20]:46430 "EHLO
	smtprelay-b31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab3BDLsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:48:41 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao5lAHefD1FV5qjOPGdsb2JhbABFhV8jhH2zNQSBARcDAQEBATg0gh8BAQQBOhwjBQsIAyElDwUlChqIHgq9SxWNNoMmYQOWHoYAjU8
X-IronPort-AV: E=Sophos;i="4.84,600,1355094000"; 
   d="scan'208";a="275697547"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 4 Feb 2013 12:54:43 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] Support of Nexio 42" and new default class for
 hid-multitouch
Message-ID: <20130204115443.GA4405@polaris.bitmath.org>
References: <1359649351-11092-1-git-send-email-benjamin.tissoires@gmail.com>
 <20130203130731.GA2677@polaris.bitmath.org>
 <CAN+gG=GRS+fx4c3Kdba-89+ba8soimMm_rv7HDuaZLZWseQGuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=GRS+fx4c3Kdba-89+ba8soimMm_rv7HDuaZLZWseQGuQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> Thanks for the review. However, before sending a new patch series, I'd
> like to have your answers to my comments as I mostly disagree on
> everything :)

With good reason, apparently. :-) I see no major problem with your
patches, although the discussed details show that there is room for
some refactoring.

Thanks,
Henrik
