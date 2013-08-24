Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab3HXUwN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 16:52:13 -0400
Received: from nm21-vm7.access.bullet.mail.bf1.yahoo.com ([216.109.115.134]:24434
	"EHLO nm21-vm7.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755688Ab3HXUwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 16:52:11 -0400
X-Yahoo-Newman-Id: 415592.61671.bm@smtp103.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: rE9ZN1sVM1k2BZYphMeNvm1NI5VMCzYAX1DvOqkNugDFe8a
 haLbGhIarSnIS8FCblzfbdfa4cVd8o1dCJzE8egmH5_NhEEFg8KeLxaLKtL3
 0miVW4W0_jd0sn9BLGEwxHtRwqRCb93tfgH3I0mWdABpYpwOxguYTgNcg.v3
 J0mMwuu7XztSw21TAUTKzoxLaa4057UC_6eztAuSn9OjZlAi.9xBBIuqKZ2z
 UAOs02fBth_hCaHbnjkZzPkqWayJ0iIpJGq.IaTBKSOQ7u5Cak4Gtx1jqyPX
 S1s7UtPdnOs8okoacoz7HsirbloR1Cgwb9nHLyHM9ko4.SPBa0cE8KYxf1dd
 TGqQ2TprsttVtPZRbNpK41dRVnyU9DNwxG9ctOygZ8TWBD4tkq4X_AFcZMOF
 KwzuX5aCiEnjACtfFIQgd_Ygovl6YSyswh2dMIZvTol7F1Z6o1NoIqaHKgjb
 OsKUsUdnJrtkAjUhAw0XJaTlrVXwsxDYGVAm1UZB_X77O62L6OmegR327K14
 Pp3flNsKYMxStIYrDsVGJAG5xA2igX_t2v1qPUTTQcsn5Q.Zlr1h_
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
X-Rocket-Received: from [192.168.1.4] (danielfsantos@99.70.244.137 with plain)
        by smtp103.sbc.mail.ne1.yahoo.com with SMTP; 24 Aug 2013 20:52:10 +0000 UTC
Message-ID: <52191D03.7010903@att.net>
Date: Sat, 24 Aug 2013 15:52:19 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130730 Thunderbird/17.0.7
MIME-Version: 1.0
To: linux-gpio@vger.kernel.org
CC: Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH v2] gpiolib: Fix crash when exporting non-existent gpio
References: <1377370108-2867-1-git-send-email-daniel.santos@pobox.com> <1377377305-11695-1-git-send-email-daniel.santos@pobox.com>
In-Reply-To: <1377377305-11695-1-git-send-email-daniel.santos@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hmm, git send-email didn't change my subject on the above message to 
"[PATCH v2]", not sure what I did wrong.  Sorry about that.

Daniel
