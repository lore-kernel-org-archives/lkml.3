Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbaLTSud (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 13:50:33 -0500
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:54681
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaLTSuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 13:50:32 -0500
Message-ID: <5495C4F3.6000901@googlemail.com>
Date: Sat, 20 Dec 2014 19:50:27 +0100
From: =?UTF-8?B?SG9sZ2VyIEhvZmZzdMOkdHRl?= 
	<holger.hoffstaette@googlemail.com>
Organization: Applied Asynchrony, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>
CC: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 3.18.1: broken directory with one file too many
References: <20141217212159.GA11517@fieldses.org> <5492C710.20104@googlemail.com> <20141218144856.GA18179@fieldses.org> <alpine.OSX.2.19.9992.1412180955000.62182@planck.local> <20141218151914.GB18179@fieldses.org> <pan.2014.12.18.15.42.53@googlemail.com> <20141218163254.GF18179@fieldses.org> <549303FC.9090604@googlemail.com> <20141218170653.GG18179@fieldses.org> <54932EA5.9090803@googlemail.com> <20141220180243.GA10273@fieldses.org>
In-Reply-To: <20141220180243.GA10273@fieldses.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/14 19:02, J. Bruce Fields wrote:
> Gah.  Does this fix it?

It does! Well done. :)

Reported-by: Holger Hoffstätte <holger.hoffstaette@googlemail.com>
Tested-by: Holger Hoffstätte <holger.hoffstaette@googlemail.com>

Thanks!
Holger
