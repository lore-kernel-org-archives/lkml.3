Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab3LKRuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 12:50:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36030 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084Ab3LKRt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 12:49:58 -0500
Message-ID: <52A8A5B0.2080206@zytor.com>
Date: Wed, 11 Dec 2013 09:49:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>, Jiri Kosina <jkosina@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>, Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH] binfmt_elf: fix PIE load with randomization disabled
References: <CAMe9rOo9sUQiusm8u=eFDnxYz37Cczd+97M9in=P2mNWXpH5pQ@mail.gmail.com>	<alpine.LNX.2.00.1312092154350.24835@pobox.suse.cz>	<CAMe9rOr06QeTGe4OC5_JYtfdziYj8NsRgS5=arEJY3BTqeLMVg@mail.gmail.com>	<alpine.LNX.2.00.1312092210280.24835@pobox.suse.cz>	<CAMe9rOrDmtHXZ1cA1or_XkktSPguDnH8sNLGM_oxj7bcsek4ww@mail.gmail.com>	<52A63AD4.2030101@zytor.com>	<CAMe9rOqEO271PUUkPAQu5hnZFyTX2viUXg8R0hpwDky0B-seyg@mail.gmail.com>	<52A63BF3.1000608@zytor.com>	<CAMe9rOqF5f2Wktsqf_43hwa_c20+_S+W8N5VDZ6TVqPXDh7puw@mail.gmail.com>	<52A63DCF.2060504@zytor.com>	<CAMe9rOqAV5_+H97XSnrOHxcruouC=hCjDuEkiiyM8UM0BH5CWw@mail.gmail.com>	<alpine.LNX.2.00.1312111435470.1413@pobox.suse.cz> <CAMe9rOoS6aZFCP=NNCcUuOanFcj0Y2Uq4jyC+KGC2qCR8M=s=A@mail.gmail.com>
In-Reply-To: <CAMe9rOoS6aZFCP=NNCcUuOanFcj0Y2Uq4jyC+KGC2qCR8M=s=A@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2013 05:41 AM, H.J. Lu wrote:
> 
> When -Ttext-segment=XXX is used, the program is expected to
> load at XXX, regardless -pie is used or not.
> 

"Expected to" by whom?  I think that is at the very best a matter of
interpretation.

	-hpa


