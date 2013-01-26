Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab3AZKXj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 05:23:39 -0500
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:36998 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab3AZKXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 05:23:35 -0500
X-Greylist: delayed 1243 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Jan 2013 05:23:35 EST
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.ucs.cam.ac.uk/email/scanner/
Message-ID: <5103A9C2.40206@cam.ac.uk>
Date: Sat, 26 Jan 2013 10:02:42 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
        linux-crypto@vger.kernel.org
Subject: Re: linux-next: Tree for Jan 23 (mtd/ubi and iio and crypto/crc32[c])
References: <20130123174336.47c0113740a14da7f6a92187@canb.auug.org.au> <51006DC9.30802@infradead.org> <20130123232316.GB25726@gondor.apana.org.au> <51007545.5040406@infradead.org>
In-Reply-To: <51007545.5040406@infradead.org>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2013 11:41 PM, Randy Dunlap wrote:
> On 01/23/13 15:23, Herbert Xu wrote:
>> On Wed, Jan 23, 2013 at 03:10:01PM -0800, Randy Dunlap wrote:
>>> On 01/22/13 22:43, Stephen Rothwell wrote:
>>>> Hi all,
>>>>
>>>> Changes since 20130122:
>>>>
>>>
>>>
>>> on i386:
>>>
>>> ERROR: "crc32_le" [drivers/mtd/ubi/ubi.ko] undefined!
>>> ERROR: "iio_triggered_buffer_setup" [drivers/iio/adc/max1363.ko] undefined!
>>> ERROR: "iio_triggered_buffer_cleanup" [drivers/iio/adc/max1363.ko] undefined!
>>> ERROR: "__crc32c_le" [crypto/crc32c.ko] undefined!
>>> ERROR: "crc32_le" [crypto/crc32.ko] undefined!
>>
>> Weird.  You do have CONFIG_CRC32 selected, so did it compile
>> a lib/crc32.ko or not?
> 
> Hmph, this seems to be some kind of rebuild problem.  It's not
> reproducible, so the mtd/ubi and crypto reports above are incorrect --
> please ignore them.  Only the iio one is reproducible.
> 
> Sorry about that.
> 
For iio one had a patch for a while, just not had a chance to send
a pull request to Greg until today.  Sorry for the slow response.
