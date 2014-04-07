Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbaDGRGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 13:06:33 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44988 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161AbaDGRG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 13:06:28 -0400
MIME-Version: 1.0
In-Reply-To: <1396867174.6220.4.camel@laptop.site>
References: <1396867174.6220.4.camel@laptop.site>
Date: Mon, 7 Apr 2014 10:06:26 -0700
Message-ID: <CAHA+R7NdyXY4RpqLcrNrUtmWPXNOQmW=ho+QgsGV7DptPOewFg@mail.gmail.com>
Subject: Re: proc net statistics
From: Cong Wang <cwang@twopensource.com>
To: "Ken O'Brien" <ken@kenobrien.org>
Cc: Network Development <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 7, 2014 at 3:39 AM, Ken O'Brien <ken@kenobrien.org> wrote:
> Hi,
>
> I was under the impression that statistics reported
> in /proc/{$pid}/net/dev were specific to that process, but the values
> appear to be globals, i.e., identical for all processes.
>
> Is this a bug?

That is per network-namespace statistics, so it is
not a bug.
