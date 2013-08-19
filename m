Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab3HSR3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 13:29:21 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:36318 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab3HSR3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 13:29:20 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLFa+bC-atqy9X7yFJipB69qnPP_MqDRBgag10Q2Fas6A@mail.gmail.com>
References: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420>
	<3908561D78D1C84285E8C5FCA982C28F31CBF152@ORSMSX106.amr.corp.intel.com>
	<CAGXu5jLFa+bC-atqy9X7yFJipB69qnPP_MqDRBgag10Q2Fas6A@mail.gmail.com>
Date: Mon, 19 Aug 2013 10:29:19 -0700
Message-ID: <CA+8MBbKThiU5JofYbHXNR9iUNmqn-A3K7PkAOpWATefCAwmQ0w@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/11] Add (de)compression support to pstore
From: Tony Luck <tony.luck@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jkenisto@linux.vnet.ibm.com" <jkenisto@linux.vnet.ibm.com>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "mahesh@linux.vnet.ibm.com" <mahesh@linux.vnet.ibm.com>,
        "ccross@android.com" <ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 17, 2013 at 11:32 AM, Kees Cook <keescook@chromium.org> wrote:
> Yeah, this is great. While I haven't tested it myself yet, the code
> seems to be in good shape. I acked the ram piece separately, but
> consider the entire series:
>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Applied.  This should show up in linux-next tomorrow.

Anyone using efivars as the pstore backend?  Testing reports (positive
or negative) appreciated.

-Tony
