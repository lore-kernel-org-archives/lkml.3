Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3HQScy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 14:32:54 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:48807 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab3HQScx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 14:32:53 -0400
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31CBF152@ORSMSX106.amr.corp.intel.com>
References: <20130816131403.3338.82330.stgit@aruna-ThinkPad-T420>
	<3908561D78D1C84285E8C5FCA982C28F31CBF152@ORSMSX106.amr.corp.intel.com>
Date: Sat, 17 Aug 2013 11:32:52 -0700
X-Google-Sender-Auth: pevzkVzB3U1M3eOHt4Dueyc4UZA
Message-ID: <CAGXu5jLFa+bC-atqy9X7yFJipB69qnPP_MqDRBgag10Q2Fas6A@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/11] Add (de)compression support to pstore
From: Kees Cook <keescook@chromium.org>
To: "Luck, Tony" <tony.luck@intel.com>
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

On Fri, Aug 16, 2013 at 3:15 PM, Luck, Tony <tony.luck@intel.com> wrote:
>> Needs testing with erst backend, efivars and persistent ram.
>
> Tested against ERST - works fine for me now.
>
> Need to stare at the code to see if there are any more bits that could be cleaned up.
>
> Thanks for addressing my issues from v1

Yeah, this is great. While I haven't tested it myself yet, the code
seems to be in good shape. I acked the ram piece separately, but
consider the entire series:

Reviewed-by: Kees Cook <keescook@chromium.org>

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
