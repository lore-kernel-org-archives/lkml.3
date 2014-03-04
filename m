Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbaCDT0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:26:51 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:46793 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456AbaCDT0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:26:49 -0500
MIME-Version: 1.0
In-Reply-To: <20140304190550.GB4695@kroah.com>
References: <1393959186-331-1-git-send-email-jwerner@chromium.org>
	<20140304190550.GB4695@kroah.com>
Date: Tue, 4 Mar 2014 11:26:49 -0800
X-Google-Sender-Auth: umE71Cm7a7pHX08eOxUEBJFsvW0
Message-ID: <CAODwPW-uuARyBbGr6qKeEW0+4ejreE-wMPDOSv1sOMV1OHejcA@mail.gmail.com>
Subject: Re: [PATCH 2/2] usb: Make DELAY_INIT quirk wait 100ms between Get
 Configuration requests
From: Julius Werner <jwerner@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Julius Werner <jwerner@chromium.org>, Oliver Neukum <oneukum@suse.de>,
        Luigi Semenzato <semenzato@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What am I supposed to do with this line?  :)
>

Oh damn, sorry, forgot to take that out on the second one. We have
this really annoying commit hook that adds them automatically. v2
incoming...
