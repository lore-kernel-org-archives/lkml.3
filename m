Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512Ab3IISD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 14:03:27 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:39954 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab3IISDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 14:03:25 -0400
Message-ID: <522E0D6A.9070606@cogentembedded.com>
Date: Mon, 09 Sep 2013 22:03:22 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Paul Chavent <Paul.Chavent@onera.fr>
CC: linux-usb@vger.kernel.org, gregkh@linuxfoundation.org, jhovold@gmail.com,
        fschaefer.oss@googlemail.com, jslaby@suse.cz, max@suse.de,
        giometti@enneenne.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] USB : serial : get protected tty in handle_dcd_change.
References: <1378742480-2146-1-git-send-email-paul.chavent@onera.fr> <1378742480-2146-3-git-send-email-paul.chavent@onera.fr>
In-Reply-To: <1378742480-2146-3-git-send-email-paul.chavent@onera.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09/09/2013 08:01 PM, Paul Chavent wrote:

> This patch depends on 72df17e... (PATCH 1).

    You don't need to say that when you publish the patches as a series. It's 
assumed.

> It restores the retreiving
> of a protected instance of tty.  As opposed to the serialcore.c
> dcd_change implementation, the callers of dcd_change used to
> get protected tty instance.

> Signed-off-by: Paul Chavent <paul.chavent@onera.fr>

WBR, Sergei

