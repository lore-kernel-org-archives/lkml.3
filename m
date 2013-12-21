Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab3LUUYd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 15:24:33 -0500
Received: from smtprelay-h31.telenor.se ([213.150.131.4]:47287 "EHLO
	smtprelay-h31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723Ab3LUUYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 15:24:31 -0500
X-SENDER-IP: [85.230.168.69]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq0hAOL3tVJV5qhFPGdsb2JhbAANS4tTsgOBKQMBAQEBOIJaAQEBAQIBeAYLCyEWDwkDAgECATEUBgEMCAEBh3gNsCKaQxePLIQ2AQOsGoE/
X-IronPort-AV: E=Sophos;i="4.95,528,1384297200"; 
   d="scan'208";a="438325724"
Message-ID: <52B5F96D.9050400@euromail.se>
Date: Sat, 21 Dec 2013 21:26:21 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Edel Maks <edelmaks@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] HID: multitouch: add support of other generic collections
 in hid-mt
References: <1387470191-9725-1-git-send-email-benjamin.tissoires@redhat.com> <1387470191-9725-4-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1387470191-9725-4-git-send-email-benjamin.tissoires@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> The ANTEC Touch Pad is a device which can switch from a multitouch
> touchpad to a mouse. It thus presents several generic collections which
> are currently ignored by hid-multitouch. Enable them by using the generic
> protocol. Adding also a suffix for them depending on their application.

In what way does this and the preceeding patches differ from "else if (is_pen ||
export_all_inputs)"? Adding a functional pattern which then is converted to a
generic case, such that the usual branching is bound to occur anyways, seems
unnecessary.

Thanks,
Henrik

