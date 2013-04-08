Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935246Ab3DHSBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 14:01:33 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:48065 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934309Ab3DHSBb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 14:01:31 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Marco Cesarano <marco@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 8 Apr 2013 11:01:16 -0700
Subject: RE: [ 25/68] mwifiex: cancel cmd timer and free curr_cmd in
 shutdown process
Thread-Topic: [ 25/68] mwifiex: cancel cmd timer and free curr_cmd in
 shutdown process
Thread-Index: Ac4v8E+XzNLFhFRaRMu1KAAgEOqNcgEkoloA
Message-ID: <477F20668A386D41ADCC57781B1F70430D9DE9605B@SC-VEXCH1.marvell.com>
References: <20130402221329.915209206@linuxfoundation.org>
 <20130402221332.853561408@linuxfoundation.org>
In-Reply-To: <20130402221332.853561408@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

> 3.4-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Bing Zhao <bzhao@marvell.com>
> 
> commit 084c7189acb3f969c855536166042e27f5dd703f upstream.
> 
> curr_cmd points to the command that is in processing or waiting
> for its command response from firmware. If the function shutdown
> happens to occur at this time we should cancel the cmd timer and
> put the command back to free queue.
> 
> Tested-by: Marco Cesarano <marco@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 

This patch is intended for kernel 3.8+.
Please drop it from linux-3.4.y queue.

Thanks,
Bing
