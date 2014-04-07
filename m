Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbaDGRTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 13:19:52 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:48202 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755547AbaDGRTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 13:19:37 -0400
MIME-Version: 1.0
In-Reply-To: <1396890659.3063.4.camel@mjolnir.site>
References: <1396867174.6220.4.camel@laptop.site>
	<CAHA+R7NdyXY4RpqLcrNrUtmWPXNOQmW=ho+QgsGV7DptPOewFg@mail.gmail.com>
	<1396890659.3063.4.camel@mjolnir.site>
Date: Mon, 7 Apr 2014 10:19:35 -0700
Message-ID: <CAHA+R7O+1gP4U-YiBHdJeEO1hvH41NcGoRZ5iW_W25CBaXWbnA@mail.gmail.com>
Subject: Re: proc net statistics
From: Cong Wang <cwang@twopensource.com>
To: "Ken O'Brien" <ken@kenobrien.org>
Cc: Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 7, 2014 at 10:10 AM, Ken O'Brien <ken@kenobrien.org> wrote:
>
> Ok, so then, is there a way to read per process network statistics in the proc filesystem?
>

AFAIK, we only have per-socket and per-netdev statistics, there is no
per-process one, you probably want to try cgroup, or put these processes
into a namespace.
