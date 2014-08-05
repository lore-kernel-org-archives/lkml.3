Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbaHEOJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 10:09:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbaHEOJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 10:09:07 -0400
Message-ID: <53E0E57B.8010600@suse.cz>
Date: Tue, 05 Aug 2014 16:08:59 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>, Yann Droneaud <ydroneaud@opteya.com>
CC: linux-kbuild@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        David Woodhouse <dwmw2@infradead.org>, Rob Landley <rob@landley.net>
Subject: Re: [PATCHv1 1/2] Documentation: headers_install.txt is part of kbuild
References: <20140709204915.GB32335@ravnborg.org> <cover.1405246007.git.ydroneaud@opteya.com> <bba4e1dd32c0e30b70443d70ff79187683fed9b3.1405246009.git.ydroneaud@opteya.com> <20140713211819.GA16496@ravnborg.org>
In-Reply-To: <20140713211819.GA16496@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-13 23:18, Sam Ravnborg wrote:
> On Sun, Jul 13, 2014 at 12:15:29PM +0200, Yann Droneaud wrote:
>> 'headers_install.txt' from Documentation/make/ is related to Kbuild
>> so it must be moved in Documentation/kbuild/ directory.
>>
>> As Documentation/make/ directory has only one file, it will be removed
>> as a consequence of moving 'headers_install.txt'.
>>
>> Cc: Kirill A. Shutemov <kirill@shutemov.name>
>> Cc: Michal Marek <mmarek@suse.cz>
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> Cc: Rob Landley <rob@landley.net>
>> Cc: Sam Ravnborg <sam@ravnborg.org>
>> Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
> 
> This is much better - thanks.
> Acked-by: Sam Ravnborg <sam@ravnborg.org>

Applied to kbuild.git#misc, thanks.

Michal

