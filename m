Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaFXWHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 18:07:11 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:59355 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbaFXWHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 18:07:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140624215828.GA14124@electric-eye.fr.zoreil.com>
References: <20140621015714.GX4841@wotan.suse.de> <20140621105205.GA31611@electric-eye.fr.zoreil.com>
 <20140623232107.GB27687@wotan.suse.de> <20140624215828.GA14124@electric-eye.fr.zoreil.com>
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Tue, 24 Jun 2014 15:06:47 -0700
X-Google-Sender-Auth: dC-TBZiYqsi71fiQ59UckOEHoBY
Message-ID: <CAB=NE6Xz6V20fQfMq8HtmdA2ATUpFnOyLHK5W+OvLCj9Ce9+Vg@mail.gmail.com>
Subject: Re: SmPL for automatic request_firmware_nowait() conversion
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: cocci@systeme.lip6.fr,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 2:58 PM, Francois Romieu <romieu@fr.zoreil.com> wrote:
> Thanks for the pointers.
>
> I can't help thinking that there's a bit of sensationalism in the
> timeout * num CPUs argument though. :o)

Indeed, this actually only applies to microcode which will end up
using the API for each CPU it seems.

  Luis
