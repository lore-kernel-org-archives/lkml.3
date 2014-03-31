Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbaCaLYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 07:24:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbaCaLYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 07:24:47 -0400
Message-ID: <53394F5A.5000306@redhat.com>
Date: Mon, 31 Mar 2014 13:19:54 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>, Franky Lin <frankyl@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/4] brcm80211: deinline brcmf_chip_cr4_enterdl, save
 440 bytes
References: <1396215079-7541-1-git-send-email-dvlasenk@redhat.com> <53391B89.7010304@broadcom.com> <53394F23.6080805@redhat.com>
In-Reply-To: <53394F23.6080805@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 01:18 PM, Denys Vlasenko wrote:
> The script removes "static" keyword, recompiles the .c file,
> compares the sizes, and if code size went down,
> creates a patch

Erm... I meant, "removes 'inline' keyword".
"static", or course, is not removed.
